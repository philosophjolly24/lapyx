
import { useMapScale } from "../hooks/useMapScale";
import { mapConfig } from "../scripts/mapScale";
import React from "react";

interface MapDisplayProps {
  currentMap: keyof typeof mapConfig;
  mapSide: string;
  isAttack: boolean;
}

function MapDisplay({ currentMap, mapSide, isAttack }: MapDisplayProps) {
  const { scale, mapRef } = useMapScale(currentMap);
  console.log(scale);

  return (
    <div className="relative flex items-center justify-center overflow-hidden h-[90%] w-full ">
      <img
        ref={mapRef}
        src={`/maps/${currentMap}_${mapSide}.svg`}
        alt=""
        loading="lazy"
        className={`transition-transform duration-300 ease-in-out object-contain max-h-full w-full ${
          isAttack ? "rotate-0" : "rotate-360"
        } }`}
      />
    </div>
  );
}

export default React.memo(MapDisplay);
