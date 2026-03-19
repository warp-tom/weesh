import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"

const mockOrders = [
  { id: "#SO-201", customer: "Maria Santos", items: 3, total: "₱420", status: "new", time: "2 min ago" },
  { id: "#SO-200", customer: "Jose Reyes", items: 1, total: "₱180", status: "preparing", time: "12 min ago" },
  { id: "#SO-199", customer: "Ana Cruz", items: 5, total: "₱845", status: "ready", time: "25 min ago" },
  { id: "#SO-198", customer: "Miguel Ramos", items: 2, total: "₱320", status: "picked_up", time: "40 min ago" },
  { id: "#SO-197", customer: "Rosa Garcia", items: 4, total: "₱560", status: "delivered", time: "1h ago" },
]

const statusMap: Record<string, { label: string; color: string; action?: string }> = {
  new: { label: "New", color: "bg-sky-500/10 text-sky-400 border-sky-500/20", action: "Accept" },
  preparing: { label: "Preparing", color: "bg-violet-500/10 text-violet-400 border-violet-500/20", action: "Mark Ready" },
  ready: { label: "Ready", color: "bg-amber-500/10 text-amber-400 border-amber-500/20" },
  picked_up: { label: "Picked Up", color: "bg-indigo-500/10 text-indigo-400 border-indigo-500/20" },
  delivered: { label: "Delivered", color: "bg-emerald-500/10 text-emerald-400 border-emerald-500/20" },
}

export default function StoreOrdersPage() {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-white tracking-tight">Incoming Orders</h1>
        <p className="text-slate-400 mt-1">Accept, prepare, and manage customer orders</p>
      </div>
      <Card className="bg-slate-900/80 border-slate-800">
        <CardHeader><CardTitle className="text-white">Order Queue</CardTitle></CardHeader>
        <CardContent>
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-slate-800">
                <th className="text-left py-3 px-4 text-slate-400 font-medium">Order</th>
                <th className="text-left py-3 px-4 text-slate-400 font-medium">Customer</th>
                <th className="text-left py-3 px-4 text-slate-400 font-medium">Items</th>
                <th className="text-left py-3 px-4 text-slate-400 font-medium">Total</th>
                <th className="text-left py-3 px-4 text-slate-400 font-medium">Status</th>
                <th className="text-left py-3 px-4 text-slate-400 font-medium">Time</th>
                <th className="text-right py-3 px-4 text-slate-400 font-medium">Action</th>
              </tr>
            </thead>
            <tbody>
              {mockOrders.map(o => (
                <tr key={o.id} className="border-b border-slate-800/50 hover:bg-slate-800/30">
                  <td className="py-3 px-4 text-white font-mono">{o.id}</td>
                  <td className="py-3 px-4 text-slate-300">{o.customer}</td>
                  <td className="py-3 px-4 text-slate-300">{o.items}</td>
                  <td className="py-3 px-4 text-slate-300">{o.total}</td>
                  <td className="py-3 px-4"><Badge className={statusMap[o.status]?.color}>{statusMap[o.status]?.label}</Badge></td>
                  <td className="py-3 px-4 text-slate-500">{o.time}</td>
                  <td className="py-3 px-4 text-right">
                    {statusMap[o.status]?.action && (
                      <Button size="sm" className="bg-emerald-600 hover:bg-emerald-700 text-white text-xs">
                        {statusMap[o.status]?.action}
                      </Button>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </CardContent>
      </Card>
    </div>
  )
}
