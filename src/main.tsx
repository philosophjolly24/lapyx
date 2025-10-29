import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import "@/styles/global.css";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import Layout from "@/pages/layout";
import Home from "@/pages/Home";
import Strategy from "@/pages/strategy";
import MapContextProvider from "./core/Contexts/mapContext";

createRoot(document.getElementById("root")!).render(
  <StrictMode>
    <MapContextProvider>
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<Layout />}>
            <Route index element={<Home />}></Route>
            <Route path="/strategy/:id" element={<Strategy />}></Route>
          </Route>
        </Routes>
      </BrowserRouter>
    </MapContextProvider>
  </StrictMode>
);
