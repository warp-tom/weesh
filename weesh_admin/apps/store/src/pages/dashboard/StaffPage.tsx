import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Badge } from "@/components/ui/badge"
import { Plus } from "lucide-react"

const mockStaff = [
  { name: "Lena Bautista", email: "lena@freshmarket.ph", access: "manager" },
  { name: "Carlo Dela Cruz", email: "carlo@freshmarket.ph", access: "staff" },
  { name: "Mariel Tan", email: "mariel@freshmarket.ph", access: "staff" },
]

const accessColors: Record<string, string> = {
  manager: "bg-violet-500/10 text-violet-400 border-violet-500/20",
  staff: "bg-slate-500/10 text-slate-400 border-slate-500/20",
}

export default function StaffPage() {
  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-white tracking-tight">Staff</h1>
          <p className="text-slate-400 mt-1">Manage staff accounts and access levels</p>
        </div>
        <Button className="bg-emerald-600 hover:bg-emerald-700 text-white">
          <Plus className="w-4 h-4 mr-2" /> Invite Staff
        </Button>
      </div>
      <Card className="bg-slate-900/80 border-slate-800">
        <CardHeader><CardTitle className="text-white">Team Members</CardTitle></CardHeader>
        <CardContent>
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-slate-800">
                <th className="text-left py-3 px-4 text-slate-400 font-medium">Name</th>
                <th className="text-left py-3 px-4 text-slate-400 font-medium">Email</th>
                <th className="text-left py-3 px-4 text-slate-400 font-medium">Access Level</th>
              </tr>
            </thead>
            <tbody>
              {mockStaff.map(s => (
                <tr key={s.email} className="border-b border-slate-800/50 hover:bg-slate-800/30">
                  <td className="py-3 px-4 text-white font-medium">{s.name}</td>
                  <td className="py-3 px-4 text-slate-300">{s.email}</td>
                  <td className="py-3 px-4">
                    <Badge className={accessColors[s.access]}>{s.access}</Badge>
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
