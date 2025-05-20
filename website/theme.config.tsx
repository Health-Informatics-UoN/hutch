import React from "react";
import { useConfig } from "nextra-theme-docs";
import Footer from "./components/Footer";

export default {
  docsRepositoryBase:
    "https://github.com/Health-Informatics-UoN/hutch/tree/main/website",
  logo: (
    <span
      style={{
        display: "flex",
        color: "#10263B",
      }}
    >
      <strong style={{ marginRight: "5px", marginLeft: "5px" }}>Hutch</strong>
      Documentation
    </span>
  ),
  project: {
    link: "https://github.com/Health-Informatics-UoN/hutch",
  },
  sidebar: {
    defaultMenuCollapseLevel: 1,
  },
  head() {
    const { frontMatter } = useConfig();

    return (
      <>
        <meta
          property="og:title"
          content={frontMatter.title || "Hutch Documentation"}
        />
        <meta
          property="og:description"
          content={
            frontMatter.description ||
            "Hutch provides tools for federated activities in secure environments."
          }
        />
        <title>{frontMatter.title || "Hutch Documentation"}</title>
        <link rel="icon" type="image/svg+xml" href="/images/favicon.svg" />
      </>
    );
  },
  footer: {
    content: (
      <Footer />
    ),
  },
};
