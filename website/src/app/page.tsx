"use client";

import { Hero } from "../components/hero";
import { FlickeringGrid } from "../components/flickering-grid";
import Funders from "../components/funders";

export default function Page() {
  return (
    <>
      <div className="relative z-10 mb-20">
        <Hero />
        <Funders />
      </div>
      <FlickeringGrid
        className="absolute inset-0 z-0 [mask-image:radial-gradient(1000px_circle_at_center,white,transparent)]"
        squareSize={4}
        gridGap={12}
        color="#1ea7c9"
        maxOpacity={0.3}
        flickerChance={0.5}
      />
    </>
  );
}
