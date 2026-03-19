import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Button } from "@/components/ui/button"

export default function StoreSettingsPage() {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-white tracking-tight">Store Settings</h1>
        <p className="text-slate-400 mt-1">Configure your business profile and preferences</p>
      </div>
      <Card className="bg-slate-900/80 border-slate-800">
        <CardHeader><CardTitle className="text-white">Business Info</CardTitle></CardHeader>
        <CardContent className="space-y-4">
          <div className="space-y-2">
            <Label className="text-slate-300">Business Name</Label>
            <Input defaultValue="Fresh Market PH" className="bg-slate-950 border-slate-800 text-white" />
          </div>
          <div className="space-y-2">
            <Label className="text-slate-300">Business Type</Label>
            <Input defaultValue="store" className="bg-slate-950 border-slate-800 text-white" />
          </div>
          <div className="space-y-2">
            <Label className="text-slate-300">Delivery Radius (km)</Label>
            <Input type="number" defaultValue="5" className="bg-slate-950 border-slate-800 text-white" />
          </div>
          <Button className="bg-emerald-600 hover:bg-emerald-700 text-white">Save Changes</Button>
        </CardContent>
      </Card>
    </div>
  )
}
