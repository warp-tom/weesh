import path from "path"
import tailwindcss from "@tailwindcss/vite"
import react from "@vitejs/plugin-react"
import { defineConfig } from "vite"

export default defineConfig({
  plugins: [react(), tailwindcss()],
  resolve: {
    alias: {
      "@/components/ui": path.resolve(__dirname, "../../packages/ui/src/components"),
      "@/lib/utils": path.resolve(__dirname, "../../packages/ui/src/lib/utils"),
      "@": path.resolve(__dirname, "./src"),
    },
  },
})
