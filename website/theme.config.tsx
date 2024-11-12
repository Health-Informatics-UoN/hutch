// https://nextra.site/docs/docs-theme/theme-configuration
import { Rabbit, Package } from "lucide-react";
import {Image} from "next/image"

export default {
  logo: (
    <span
      style={{
        display: "flex",
        color: "#0E7490",
      }}
    >
      <Rabbit style={{ marginRight: "5px" }} />
      +
      <Package style={{ marginRight: "5px" }} />
      =
      <strong style={{ marginRight: "5px" }}>Hutch</strong>Documentation
    </span>
  ),
  project: {
    link: "https://github.com/Health-Informatics-UoN/hutch",
  },
  head: (
    <>
      <link rel="icon" type="image/svg+xml" href="/images/favicon.svg" />
    </>
  ),
  footer: {
    content: (
      <span>
        ©{new Date().getFullYear()}{" "}
        <a href="https://nottingham.ac.uk" target="_blank">
          <Image src="/images/uon_white_text_web.png" alt="University of Nottingham"/>
        </a>
        <br />
        MIT licence
      </span>
    ),
  },
};
