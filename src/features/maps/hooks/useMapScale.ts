import { useEffect, useRef, useState } from "react";
import { mapConfig } from "../scripts/mapScale";

export function useMapScale(currentMap: keyof typeof mapConfig) {
  const mapRef = useRef<HTMLImageElement>(null);
  const [scale, setScale] = useState<number | null>(null);
  const [width, setWidth] = useState<number | null>(null);
  const [height, setHeight] = useState<number | null>(null);

  useEffect(() => {
    if (!mapRef.current) return;

    const updateScale = () => {
      const { width, height } = mapRef.current!.getBoundingClientRect();
      const { baseImageWidth, pixelsPerMeter } = mapConfig[currentMap];
      const scaleFactor = width / baseImageWidth;
      const scaledPixelsPerMeter = pixelsPerMeter * scaleFactor;

      setWidth(width);
      setHeight(height);
      setScale(scaledPixelsPerMeter);
    };

    updateScale();

    // Update on resize or zoom
    window.addEventListener("resize", updateScale);
    return () => window.removeEventListener("resize", updateScale);
  }, [currentMap]);

  return { mapRef, scale, width, height };
}
