"use client";

import Funders from "@/components/funders";
import { Hero } from "@/components/hero";
import { FlickeringGrid } from "@/components/flickering-grid";

export default function Page() {
  return (
    <div>
      <Hero />
      <Funders />
      <FlickeringGrid
        className="absolute inset-0 z-0 [mask-image:radial-gradient(1000px_circle_at_center,white,transparent)]"
        squareSize={4}
        gridGap={12}
        color="#6B7280"
        maxOpacity={0.5}
        flickerChance={0.5}
      />
    </div>
  );
}
