import { Book, Code } from "lucide-react";
import { Roboto } from "next/font/google";

import { cn } from "../lib/utils";
import { ShimmerButton } from "./shimmer-button";
import Link from "next/link";

const font = Roboto({ weight: "500", subsets: ["latin"] });
export const Hero = () => {
  return (
    <div className="px-6 lg:px-8">
      <div className="mx-auto max-w-2xl py-32 sm:py-32 lg:py-24">
        <div className="mb-8 flex justify-center">
          <img alt="" src="./logos/bunny1.png" className="h-36 w-auto" />
        </div>
        <div className="text-center">
          <h1
            className={cn(
              "text-3xl font-semibold tracking-tight text-balance text-sky-700 sm:text-6xl",
              font.className
            )}
          >
            Your Secure Gateway to OMOP Cohort Discovery
          </h1>
          <div className="mt-16 flex items-center justify-center gap-x-6">
            <Link href="https://github.com/Health-Informatics-UoN/hutch-bunny">
              <ShimmerButton className="shadow-2xl flex" background="#0d6e9e">
                <span
                  className={cn(
                    "flex items-center gap-2 opacity-90 whitespace-pre-wrap text-center text-sm font-medium leading-none tracking-tight text-white dark:from-white dark:to-slate-900/10 lg:text-xl",
                    font.className
                  )}
                >
                  GitHub Repo <Code className="opacity-85" />
                </span>
              </ShimmerButton>
            </Link>
            <Link href="/bunny">
              <ShimmerButton className="shadow-2xl flex" background="#0d6e9e">
                <span
                  className={cn(
                    "flex items-center gap-2 opacity-90 whitespace-pre-wrap text-center text-sm font-medium leading-none tracking-tight text-white dark:from-white dark:to-slate-900/10 lg:text-xl",
                    font.className
                  )}
                >
                  Explore Docs Today! <Book className="opacity-85" />
                </span>
              </ShimmerButton>
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
};
