import { createContext, useEffect, useState, type ReactNode } from "react"
import { supabase } from "@/lib/supabase"
import type { User, Session } from "@supabase/supabase-js"

interface AuthContextType {
  user: User | null
  session: Session | null
  role: string | null
  merchantId: string | null
  loading: boolean
  signOut: () => Promise<void>
}

export const AuthContext = createContext<AuthContextType>({
  user: null,
  session: null,
  role: null,
  merchantId: null,
  loading: true,
  signOut: async () => {},
})

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null)
  const [session, setSession] = useState<Session | null>(null)
  const [role, setRole] = useState<string | null>(null)
  const [merchantId, setMerchantId] = useState<string | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    supabase.auth.getSession().then(({ data: { session } }) => {
      setSession(session)
      setUser(session?.user ?? null)
      if (session?.user) {
        fetchRole(session.user.id)
      } else {
        setLoading(false)
      }
    })

    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      setSession(session)
      setUser(session?.user ?? null)
      if (session?.user) {
        fetchRole(session.user.id)
      } else {
        setRole(null)
        setMerchantId(null)
        setLoading(false)
      }
    })

    return () => subscription.unsubscribe()
  }, [])

  async function fetchRole(userId: string) {
    try {
      const { data: userData } = await supabase
        .from("users")
        .select("role")
        .eq("id", userId)
        .single()

      const userRole = userData?.role ?? null
      setRole(userRole)

      if (userRole === "merchant") {
        setMerchantId(userId)
      } else if (userRole === "store_staff") {
        const { data: staffData } = await supabase
          .from("store_staff")
          .select("merchant_id")
          .eq("id", userId)
          .single()
        setMerchantId(staffData?.merchant_id ?? null)
      }
    } catch {
      setRole(null)
    } finally {
      setLoading(false)
    }
  }

  const signOut = async () => {
    await supabase.auth.signOut()
    setUser(null)
    setSession(null)
    setRole(null)
    setMerchantId(null)
  }

  return (
    <AuthContext.Provider value={{ user, session, role, merchantId, loading, signOut }}>
      {children}
    </AuthContext.Provider>
  )
}
