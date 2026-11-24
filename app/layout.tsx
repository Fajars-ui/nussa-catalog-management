import type { Metadata } from "next";
import "./globals.css";
export const metadata: Metadata = {
  title: "NUSSA | Katalog Busana Adat Nusantara",
  description: "Katalog penyewaan busana adat NUSSA Pontianak."
};
export default function RootLayout({children}:{children:React.ReactNode}) {
  return <html lang="id"><body>{children}</body></html>;
}
