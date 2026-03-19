import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"

export default function AnalyticsPage() {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-white tracking-tight">Analytics</h1>
        <p className="text-slate-400 mt-1">Revenue, top products, and order trends</p>
      </div>
      <div className="grid grid-cols-3 gap-4">
        {[
          { label: "Total Revenue", value: "₱84,320", change: "+18% this month" },
          { label: "Orders This Month", value: "342", change: "+23% vs last" },
          { label: "Top Product", value: "Organic Bananas", change: "87 sold" },
        ].map(s => (
          <Card key={s.label} className="bg-slate-900/80 border-slate-800">
            <CardHeader className="pb-2"><CardTitle className="text-sm text-slate-400">{s.label}</CardTitle></CardHeader>
            <CardContent>
              <div className="text-2xl font-bold text-white">{s.value}</div>
              <p className="text-xs text-emerald-400 mt-1">{s.change}</p>
            </CardContent>
          </Card>
        ))}
      </div>
      <Card className="bg-slate-900/80 border-slate-800">
        <CardHeader><CardTitle className="text-white">Sales Chart</CardTitle></CardHeader>
        <CardContent>
          <p className="text-slate-400 text-sm">Chart integration coming soon (recharts / chart.js)</p>
        </CardContent>
      </Card>
    </div>
  )
}
