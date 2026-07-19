import type { Metadata } from "next";
import ReviewConsole from "./ReviewConsole";

export const metadata: Metadata = {
  description:
    "A credential-free evidence replay demonstrating a controlled meeting action tracker with mandatory human review.",
};

export default function Home() {
  return <ReviewConsole />;
}
