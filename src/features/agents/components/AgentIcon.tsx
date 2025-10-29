import { useRef, useEffect, use } from "react";
import { draggable } from "@atlaskit/pragmatic-drag-and-drop/element/adapter";
import { MapContext } from "@/core/Contexts/mapContext";
import { disableNativeDragPreview } from "@atlaskit/pragmatic-drag-and-drop/element/disable-native-drag-preview";
import type { agent } from "../scripts/agents";

export default function AgentIcon({ agent }: { agent: agent }) {
  const ref = useRef(null);
  const { pos, setPos } = use(MapContext);

  useEffect(() => {
    const el = ref.current;
    if (!el) {
      throw new Error("ref not set correctly");
    }

    draggable({
      // The simplest form only needs the element reference
      element: el,
      onGenerateDragPreview({ nativeSetDragImage }) {
        disableNativeDragPreview({ nativeSetDragImage });
      },
      onDragStart: (event) => {
        console.log("Drag started", event);
      },
      onDrag: (event) => {
        const clientX = event.location.current.input.clientX;
        const clientY = event.location.current.input.clientY;

        setPos({ x: clientX, y: clientY });
      },
      onDrop: (event) => {
        console.log("Dropped", event);
      },
    });
  }, [setPos]);
  console.log(pos);
  return (
    <>
      {pos && (
        <img
          src={`/icons/${agent.name}/icon.svg`}
          style={{
            position: "fixed",
            top: pos.y,
            left: pos.x,
            pointerEvents: "none",
            transform: "translate(-50%, -50%)",
          }}
          className="w-8 h-8"
        />
      )}
      <div className=" flex items-center justify-center h-fit w-fit bg-main/25 rounded-md  my-4 ml-3">
        <img
          src={`/agents/${agent.name}/icon.webp`}
          alt={`${agent.name}`}
          width={32}
          height={32}
          className="object-contain h-full w-fit rounded-md"
          ref={ref}
        />
      </div>
    </>
  );
}
