import type { Dispatch, SetStateAction } from "react";
import { Menu, MenuButton, MenuItem, MenuItems } from "@headlessui/react";
import { currentMapPool, outOfRotation } from "@/features/maps/scripts/maps";
import type { mapConfig } from "../scripts/mapScale";

interface MapPickerProps {
  currentMap: string;
  setCurrentMap: Dispatch<SetStateAction<keyof typeof mapConfig>>;
}

export default function MapPicker({
  setCurrentMap,
  currentMap,
}: MapPickerProps) {
  return (
    <Menu>
      <MenuButton className="focus:outline-0">
        <div
          style={{ backgroundImage: `url(/thumbnails/${currentMap}.webp)` }}
          className={`bg-black/30  bg-cover h-16 w-67 flex  items-center justify-center bg-blend-multiply rounded-md`}
        >
          <p className="text-off-white text-3xl grow text-center my-auto font-bold tracking-wide">
            {currentMap.slice(0, 1).toUpperCase() + currentMap.slice(1)}
          </p>
        </div>
      </MenuButton>
      <MenuItems
        anchor="bottom"
        className="bg-[#5f377b] rounded-md focus:outline-0"
      >
        {currentMapPool.map((curr) => {
          return (
            <MenuItem key={curr}>
              <div
                onClick={() => {
                  setCurrentMap(curr);
                }}
                style={{
                  backgroundImage: `url(/thumbnails/${curr}.webp)`,
                }}
                className={`bg-black/30  bg-cover h-16 w-67 flex  items-center justify-center bg-blend-multiply rounded-md m-1.5`}
              >
                <p className="text-off-white text-3xl grow text-center my-auto font-bold tracking-wide">
                  {curr.slice(0, 1).toUpperCase() + curr.slice(1)}
                </p>
              </div>
            </MenuItem>
          );
        })}{" "}
        <p className="text-off-white text-3xl grow text-center my-auto font-bold p-2 text-shadow-md">
          {`Out Of Rotation`}
        </p>
        {outOfRotation.map((curr) => {
          return (
            <MenuItem key={curr}>
              <div
                onClick={() => {
                  setCurrentMap(curr);
                }}
                style={{
                  backgroundImage: `url(/thumbnails/${curr}.webp)`,
                }}
                className={`bg-black/30   bg-cover h-16 w-67 flex  items-center justify-center bg-blend-multiply rounded-md m-1.5`}
              >
                <p className="text-off-white text-3xl grow text-center my-auto font-bold tracking-wide">
                  {curr.slice(0, 1).toUpperCase() + curr.slice(1)}
                </p>
              </div>
            </MenuItem>
          );
        })}
      </MenuItems>
    </Menu>
  );
}
