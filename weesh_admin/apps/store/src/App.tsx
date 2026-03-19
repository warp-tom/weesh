import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom"
import { AuthProvider } from "@/hooks/AuthProvider"
import StoreLoginPage from "./pages/auth/LoginPage"
import { StoreDashboardLayout } from "@/components/layout/StoreDashboardLayout"
import ProductsPage from "./pages/dashboard/ProductsPage"
import StoreOrdersPage from "./pages/dashboard/StoreOrdersPage"
import AnalyticsPage from "./pages/dashboard/AnalyticsPage"
import StaffPage from "./pages/dashboard/StaffPage"
import StoreSettingsPage from "./pages/dashboard/StoreSettingsPage"

export function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <Routes>
          {/* Public */}
          <Route path="/login" element={<StoreLoginPage />} />
          <Route path="/" element={<Navigate to="/login" replace />} />

          {/* Protected merchant/store_staff dashboard */}
          <Route path="/dashboard" element={<StoreDashboardLayout />}>
            <Route index element={<Navigate to="orders" replace />} />
            <Route path="products" element={<ProductsPage />} />
            <Route path="orders" element={<StoreOrdersPage />} />
            <Route path="analytics" element={<AnalyticsPage />} />
            <Route path="staff" element={<StaffPage />} />
            <Route path="settings" element={<StoreSettingsPage />} />
          </Route>

          <Route path="*" element={<Navigate to="/login" replace />} />
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  )
}
