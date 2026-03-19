
import { Badge } from "@workspace/ui/components/badge";
import { Button } from "@workspace/ui/components/button";
import { Card, CardContent, CardHeader, CardTitle } from "@workspace/ui/components/card";
import { AlertCircle, Navigation, Map as MapIcon, Users } from "lucide-react";

export function AdminHeatmap() {
  return (
    <div className="flex flex-col h-screen bg-background dark p-6 font-sans">
      
      {/* Header */}
      <div className="flex justify-between items-center mb-6">
        <div>
          <h1 className="text-3xl font-bold tracking-tight glow-text-primary">Weesh Command Center</h1>
          <p className="text-muted-foreground mt-1">Live Dispatch & Routing Heatmap - Tiaong Zone</p>
        </div>
        
        <div className="flex gap-4">
          <Badge variant="outline" className="px-4 py-2 border-primary text-primary bg-primary/10">
            <span className="w-2 h-2 rounded-full bg-primary mr-2 animate-pulse glow-primary"></span>
            86 Active Drivers
          </Badge>
          <Badge variant="outline" className="px-4 py-2 border-accent text-accent bg-accent/10">
            <span className="w-2 h-2 rounded-full bg-accent mr-2 animate-pulse glow-accent"></span>
            14 Pending Weeshes
          </Badge>
        </div>
      </div>

      <div className="grid grid-cols-12 gap-6 h-full">
        
        {/* PostGIS Heatmap Placeholder */}
        <div className="col-span-8 rounded-xl border border-white/10 overflow-hidden relative glass-panel">
          <div className="absolute inset-0 bg-secondary/5 z-0"></div>
          
          <div className="absolute top-4 left-4 z-10 flex gap-2">
            <Button variant="secondary" size="sm" className="bg-background/80 backdrop-blur">
              <MapIcon className="w-4 h-4 mr-2"/> Default Layer
            </Button>
            <Button variant="secondary" size="sm" className="bg-background/80 backdrop-blur">
              Heatmap Overlay
            </Button>
          </div>

          <div className="h-full w-full flex items-center justify-center flex-col text-muted-foreground z-10 relative">
             <Navigation className="w-16 h-16 mb-4 text-primary/50 animate-pulse glow-primary"/>
             <span className="font-mono text-sm tracking-widest text-primary/70">POSTGIS SPATIAL STREAM CONNECTED</span>
             <p className="mt-2 text-xs">Waiting for Mapbox GL JS context...</p>
          </div>
        </div>

        {/* 1-Click Verification Queue */}
        <div className="col-span-4 flex flex-col gap-6">
          <Card className="glass-panel border-white/10 bg-background/50 h-1/2 flex flex-col">
            <CardHeader className="pb-3 border-b border-white/5">
              <CardTitle className="text-lg flex items-center font-bold">
                <AlertCircle className="w-5 h-5 mr-2 text-secondary glow-text-secondary"/> 
                Verification Queue
              </CardTitle>
            </CardHeader>
            <CardContent className="flex-1 overflow-auto p-0">
               {/* Queue Items */}
               <div className="p-4 border-b border-white/5 hover:bg-white/5 transition-colors cursor-pointer">
                  <div className="flex justify-between items-start mb-2">
                    <span className="font-semibold text-sm">Kuya Lito (Tricycle #84)</span>
                    <Badge variant="secondary" className="text-[10px] bg-secondary/20 text-secondary">New Driver</Badge>
                  </div>
                  <p className="text-xs text-muted-foreground mb-3">Pending local zone approval for San Antonio boundary.</p>
                  <div className="flex gap-2">
                    <Button size="sm" className="w-full bg-primary hover:bg-primary/90 text-primary-foreground font-bold text-xs glow-primary">Verify 1-Click</Button>
                    <Button size="sm" variant="outline" className="w-full text-xs">Reject</Button>
                  </div>
               </div>

               <div className="p-4 border-b border-white/5 hover:bg-white/5 transition-colors cursor-pointer opacity-70">
                  <div className="flex justify-between items-start mb-2">
                    <span className="font-semibold text-sm">Mang Juan (Grocery)</span>
                    <Badge variant="outline" className="text-[10px] border-accent text-accent">Dispute</Badge>
                  </div>
                  <p className="text-xs text-muted-foreground mb-3">Item missing from delivery receipt #4421.</p>
                  <div className="flex gap-2">
                    <Button size="sm" className="w-full bg-accent hover:bg-accent/90 text-accent-foreground font-bold text-xs glow-accent">Review</Button>
                  </div>
               </div>
            </CardContent>
          </Card>

          <Card className="glass-panel border-white/10 bg-background/50 h-1/2 flex flex-col">
            <CardHeader className="pb-3 border-b border-white/5">
              <CardTitle className="text-lg flex items-center font-bold text-primary glow-text-primary">
                <Users className="w-5 h-5 mr-2"/> 
                God-Mode Dispatch
              </CardTitle>
            </CardHeader>
            <CardContent className="flex-1 p-6 flex flex-col items-center justify-center text-center">
               <div className="w-16 h-16 rounded-full bg-primary/20 flex items-center justify-center mb-4 neon-glow-primary">
                  <Navigation className="w-8 h-8 text-primary"/>
               </div>
               <h3 className="font-bold text-lg mb-2">Manual Override</h3>
               <p className="text-sm text-muted-foreground mb-6">Force dispatch a driver to a high-priority rural Weesh ignoring standard radius limits.</p>
               <Button className="w-full bg-primary hover:bg-primary/90 glow-primary h-12 text-md font-bold">Select Driver & Assign</Button>
            </CardContent>
          </Card>

        </div>
      </div>
    </div>
  );
}
