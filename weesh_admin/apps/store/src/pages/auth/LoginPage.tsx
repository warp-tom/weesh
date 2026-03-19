import { useState } from "react"
import { motion } from "framer-motion"
import { useNavigate } from "react-router-dom"
import { supabase } from "@/lib/supabase"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { Label } from "@/components/ui/label"
import { Loader2, Store } from "lucide-react"

export default function StoreLoginPage() {
  const [email, setEmail] = useState("")
  const [password, setPassword] = useState("")
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const navigate = useNavigate()

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    setError(null)

    try {
      const { data, error: signInError } = await supabase.auth.signInWithPassword({ email, password })
      if (signInError) throw signInError
      if (data.user) {
        const { data: userData, error: userError } = await supabase
          .from("users").select("role").eq("id", data.user.id).single()
        if (userError) throw userError
        if (userData.role !== "merchant" && userData.role !== "store_staff") {
          await supabase.auth.signOut()
          throw new Error("Access denied. Merchant or staff account required.")
        }
        navigate("/dashboard")
      }
    } catch (err: unknown) {
      setError((err instanceof Error ? err.message : null) || "Login failed.")
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen bg-slate-950 flex items-center justify-center p-4 relative overflow-hidden font-sans">
      <div className="absolute top-0 left-0 w-full h-full overflow-hidden z-0 pointer-events-none">
        <div className="absolute top-[20%] left-[30%] w-[30%] h-[40%] rounded-full bg-emerald-600/10 blur-[100px]" />
        <div className="absolute bottom-[10%] right-[20%] w-[35%] h-[30%] rounded-full bg-teal-600/10 blur-[100px]" />
      </div>

      <motion.div initial={{ opacity: 0, scale: 0.95 }} animate={{ opacity: 1, scale: 1 }}
        transition={{ duration: 0.4 }} className="w-full max-w-md z-10">
        <Card className="bg-slate-900/80 border-slate-800 backdrop-blur-xl shadow-2xl">
          <CardHeader className="space-y-3 pb-6 border-b border-slate-800">
            <div className="flex justify-center mb-2">
              <div className="w-10 h-10 rounded-lg bg-gradient-to-tr from-emerald-500 to-teal-500 flex items-center justify-center shadow-lg shadow-emerald-500/20">
                <Store className="w-5 h-5 text-white" />
              </div>
            </div>
            <CardTitle className="text-2xl font-bold text-center text-white tracking-tight">Store Portal</CardTitle>
            <CardDescription className="text-center text-slate-400">
              Sign in to manage your business
            </CardDescription>
          </CardHeader>
          <form onSubmit={handleLogin}>
            <CardContent className="space-y-4 pt-6">
              {error && (
                <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }}
                  className="bg-red-500/10 border border-red-500/20 text-red-400 text-sm p-3 rounded-md">{error}</motion.div>
              )}
              <div className="space-y-2">
                <Label htmlFor="email" className="text-slate-300">Email</Label>
                <Input id="email" type="email" required value={email} onChange={e => setEmail(e.target.value)}
                  className="bg-slate-950 border-slate-800 text-white placeholder:text-slate-600 focus-visible:ring-emerald-500 h-11" placeholder="store@weesh.com" />
              </div>
              <div className="space-y-2">
                <Label htmlFor="password" className="text-slate-300">Password</Label>
                <Input id="password" type="password" required value={password} onChange={e => setPassword(e.target.value)}
                  className="bg-slate-950 border-slate-800 text-white focus-visible:ring-emerald-500 h-11" />
              </div>
            </CardContent>
            <CardFooter className="pt-2 pb-6">
              <Button type="submit" disabled={loading}
                className="w-full h-11 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg shadow-lg shadow-emerald-600/20 font-medium">
                {loading ? <><Loader2 className="mr-2 h-4 w-4 animate-spin" />Authenticating...</> : "Sign In"}
              </Button>
            </CardFooter>
          </form>
        </Card>
      </motion.div>
    </div>
  )
}
