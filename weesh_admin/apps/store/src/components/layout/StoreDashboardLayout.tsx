import { Outlet, Navigate, NavLink, useNavigate } from "react-router-dom"
import { useAuth } from "@/hooks/useAuth"
import { cn } from "@/lib/utils"
import { Loader2, Package, ShoppingCart, Settings, Users, BarChart3, LogOut, Store } from "lucide-react"

const ownerNav = [
  { label: "Products", icon: Package, path: "/dashboard/products" },
  { label: "Orders", icon: ShoppingCart, path: "/dashboard/orders" },
  { label: "Analytics", icon: BarChart3, path: "/dashboard/analytics" },
  { label: "Staff", icon: Users, path: "/dashboard/staff" },
  { label: "Settings", icon: Settings, path: "/dashboard/settings" },
]

const staffNav = [
  { label: "Products", icon: Package, path: "/dashboard/products" },
  { label: "Orders", icon: ShoppingCart, path: "/dashboard/orders" },
]

export function StoreDashboardLayout() {
  const { user, role, loading, signOut } = useAuth()
  const navigate = useNavigate()

  if (loading) {
    return (
      <div className="min-h-screen bg-slate-950 flex items-center justify-center">
        <Loader2 className="w-8 h-8 animate-spin text-emerald-500" />
      </div>
    )
  }

  if (!user || (role !== "merchant" && role !== "store_staff")) {
    return <Navigate to="/login" replace />
  }

  const navItems = role === "merchant" ? ownerNav : staffNav

  const handleSignOut = async () => {
    await signOut()
    navigate("/login")
  }

  return (
    <div className="flex min-h-screen bg-slate-950 text-slate-50">
      {/* Sidebar */}
      <aside className="h-screen sticky top-0 w-[240px] flex flex-col bg-slate-900 border-r border-slate-800 z-30">
        <div className="flex items-center gap-2 px-4 h-16 border-b border-slate-800 shrink-0">
          <div className="w-8 h-8 rounded bg-gradient-to-tr from-emerald-500 to-teal-500 flex items-center justify-center shadow-lg shadow-emerald-500/20 shrink-0">
            <Store className="w-4 h-4 text-white" />
          </div>
          <span className="font-bold text-lg text-white tracking-tight">Store Portal</span>
        </div>
        <nav className="flex-1 overflow-y-auto py-4 px-2 space-y-1">
          {navItems.map(item => (
            <NavLink key={item.path} to={item.path}
              className={({ isActive }) => cn(
                "flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-colors",
                isActive ? "bg-emerald-600/15 text-emerald-400" : "text-slate-400 hover:text-white hover:bg-slate-800/60"
              )}>
              <item.icon className="w-5 h-5 shrink-0" />
              <span>{item.label}</span>
            </NavLink>
          ))}
        </nav>
        <div className="border-t border-slate-800 p-3">
          {user && <p className="text-xs text-slate-500 truncate px-2 pb-2">{user.email}</p>}
          <button onClick={handleSignOut}
            className="flex items-center gap-3 w-full px-3 py-2 rounded-lg text-sm text-slate-400 hover:text-red-400 hover:bg-red-500/10 transition-colors">
            <LogOut className="w-5 h-5 shrink-0" /><span>Sign Out</span>
          </button>
        </div>
      </aside>
      <main className="flex-1 overflow-auto">
        <header className="sticky top-0 z-20 h-16 border-b border-slate-800 bg-slate-950/80 backdrop-blur-md flex items-center px-8">
          <h2 className="text-lg font-semibold text-white">Store Dashboard</h2>
        </header>
        <div className="p-8"><Outlet /></div>
      </main>
    </div>
  )
}
