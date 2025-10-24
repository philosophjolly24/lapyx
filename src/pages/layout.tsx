import "@/styles/background/bg.css";
import { Outlet } from "react-router-dom";

export default function Layout() {
  return (
    <div className="w-screen max-h-screen  overflow-hidden bg-svg  ">
      <main className="w-full h-full flex overflow-hidden">
        <Outlet />
      </main>
    </div>
  );
}
