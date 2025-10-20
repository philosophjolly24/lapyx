import type { Dispatch, SetStateAction } from "react";
import { Menu, MenuButton, MenuItem, MenuItems } from "@headlessui/react";
import { maps } from "@/core/scripts/maps";

interface MapPickerProps {
  currentMap: string;
  setCurrentMap: Dispatch<SetStateAction<string>>;
}

export default function MapPicker({
  setCurrentMap,
  currentMap,
}: MapPickerProps) {
  return (
    <Menu>
      <MenuButton>
        <div
          style={{ backgroundImage: `url(/thumbnails/${currentMap}.webp)` }}
          className={`bg-black/30  bg-cover h-16 w-67 flex  items-center justify-center bg-blend-multiply rounded-md`}
        >
          <p className="text-off-white text-3xl grow text-center my-auto font-bold">
            {currentMap.slice(0, 1).toUpperCase() + currentMap.slice(1)}
          </p>
        </div>
      </MenuButton>
      <MenuItems anchor="bottom" className="bg-black/30 rounded-md">
        {maps.map((curr) => {
          return (
            <MenuItem key={curr}>
              <div
                onClick={() => {
                  setCurrentMap(curr);
                  console.log(currentMap);
                }}
                style={{
                  backgroundImage: `url(/thumbnails/${curr}.webp)`,
                }}
                className={`bg-black/45  bg-cover h-16 w-67 flex  items-center justify-center bg-blend-multiply rounded-md m-1.5`}
              >
                <p className="text-off-white text-3xl grow text-center my-auto font-bold">
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
