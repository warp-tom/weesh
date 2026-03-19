import { useState } from "react"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Badge } from "@/components/ui/badge"
import { Search, Plus, MoreHorizontal } from "lucide-react"

const mockProducts = [
  { id: 1, name: "Organic Bananas (1kg)", price: "₱85", stock: 120, category: "Fruits", active: true },
  { id: 2, name: "Fresh Eggs (12pcs)", price: "₱180", stock: 45, category: "Dairy", active: true },
  { id: 3, name: "White Rice (5kg)", price: "₱320", stock: 0, category: "Grains", active: false },
  { id: 4, name: "Chicken Breast (500g)", price: "₱210", stock: 32, category: "Meat", active: true },
  { id: 5, name: "Calamansi Juice (1L)", price: "₱65", stock: 80, category: "Beverages", active: true },
]

export default function ProductsPage() {
  const [search, setSearch] = useState("")
  const filtered = mockProducts.filter(p => p.name.toLowerCase().includes(search.toLowerCase()))

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-white tracking-tight">Products</h1>
          <p className="text-slate-400 mt-1">Manage your catalog</p>
        </div>
        <Button className="bg-emerald-600 hover:bg-emerald-700 text-white">
          <Plus className="w-4 h-4 mr-2" /> Add Product
        </Button>
      </div>
      <div className="relative max-w-sm">
        <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-500" />
        <Input placeholder="Search products..." value={search} onChange={e => setSearch(e.target.value)}
          className="pl-10 bg-slate-900 border-slate-800 text-white placeholder:text-slate-500" />
      </div>
      <Card className="bg-slate-900/80 border-slate-800">
        <CardHeader><CardTitle className="text-white">Product Catalog</CardTitle></CardHeader>
        <CardContent>
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-slate-800">
                <th className="text-left py-3 px-4 text-slate-400 font-medium">Product</th>
                <th className="text-left py-3 px-4 text-slate-400 font-medium">Category</th>
                <th className="text-left py-3 px-4 text-slate-400 font-medium">Price</th>
                <th className="text-left py-3 px-4 text-slate-400 font-medium">Stock</th>
                <th className="text-left py-3 px-4 text-slate-400 font-medium">Status</th>
                <th className="text-right py-3 px-4 text-slate-400 font-medium">Actions</th>
              </tr>
            </thead>
            <tbody>
              {filtered.map(p => (
                <tr key={p.id} className="border-b border-slate-800/50 hover:bg-slate-800/30">
                  <td className="py-3 px-4 text-white font-medium">{p.name}</td>
                  <td className="py-3 px-4 text-slate-300">{p.category}</td>
                  <td className="py-3 px-4 text-slate-300">{p.price}</td>
                  <td className="py-3 px-4 text-slate-300">{p.stock}</td>
                  <td className="py-3 px-4">
                    <Badge className={p.active ? "bg-emerald-500/10 text-emerald-400 border-emerald-500/20" : "bg-slate-500/10 text-slate-400 border-slate-500/20"}>
                      {p.active ? "Active" : "Out of Stock"}
                    </Badge>
                  </td>
                  <td className="py-3 px-4 text-right">
                    <Button variant="ghost" size="icon" className="text-slate-400 hover:text-white">
                      <MoreHorizontal className="w-4 h-4" />
                    </Button>
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
