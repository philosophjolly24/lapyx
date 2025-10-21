import "@/styles/background/bg.css";
import { Outlet } from "react-router-dom";

export default function Layout() {
  return (
    <div className="w-svw h-lvh bg-svg">
      <main className="w-full h-full  mx-auto px-5">
        <Outlet />
      </main>
    </div>
  );
}
