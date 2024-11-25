import { Rabbit, Package } from "lucide-react";
import React from "react";
import { useRouter } from 'next/router'
import { useConfig } from 'nextra-theme-docs'

export default {
  logo: (
    <span
      style={{
        display: "flex",
        color: "#0E7490",
      }}
    >
      <Rabbit style={{ marginRight: "3px" }} />
      +
      <Package style={{ marginRight: "5px", marginLeft: "3px" }} />=
      <strong style={{ marginRight: "5px", marginLeft: "5px" }}>Hutch</strong>
      Documentation
    </span>
  ),
  project: {
    link: "https://github.com/Health-Informatics-UoN/hutch",
  },
  head() {
    const { frontMatter } = useConfig()
 
    return (
      <>
        <meta property="og:title" content={frontMatter.title || 'Hutch Documentation'} />
        <meta
          property="og:description"
          content={frontMatter.description || 'Hutch provides tools for federated activities in secure environments.'}
        />
        <title>{frontMatter.title || 'Hutch Documentation'}</title>
        <link rel="icon" type="image/svg+xml" href="/hutch/images/favicon.svg" />
      </>
    )
  },
  footer: {
    content: (
      <span>
        © {new Date().getFullYear()}{" "}
        <a href="https://nottingham.ac.uk" target="_blank">
          <img
            src="/hutch/images/uon_white_text_web.png"
            alt="University of Nottingham"
            width={243}
            height={90}
          />
        </a>
        <br />
        MIT licence
      </span>
    ),
  },
};
