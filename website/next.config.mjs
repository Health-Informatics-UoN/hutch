import nextra from 'nextra'
 
/**
 * @type {import('next').NextConfig}
 */
const nextConfig = {
  assetPrefix: "./",
  output: 'export',
  images: {
    unoptimized: true // mandatory, otherwise won't export
  }
  // Optional: Change the output directory `out` -> `dist`
  // distDir: "build"
}
const withNextra = nextra({
  theme: 'nextra-theme-docs',
  themeConfig: './theme.config.tsx'
})
 
export default withNextra(nextConfig)
