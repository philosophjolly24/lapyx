import { createContext, useState, type ReactNode } from "react";

interface MapContextType {
  pos: {
    x: number;
    y: number;
  } | null;

  setPos: React.Dispatch<
    React.SetStateAction<{
      x: number;
      y: number;
    } | null>
  >;
}
const MapContext = createContext<MapContextType>({
  pos: null,
  setPos: () => {},
});

export default function MapContextProvider({
  children,
}: {
  children: ReactNode;
}) {
  const [pos, setPos] = useState<{
    x: number;
    y: number;
  } | null>(null);

  return <MapContext value={{ pos, setPos }}>{children}</MapContext>;
}

export { MapContext };
