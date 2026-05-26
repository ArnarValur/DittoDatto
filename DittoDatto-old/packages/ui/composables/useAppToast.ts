// export const useAppToast = () => {
//   const toast = useToast();

//   const add = (options: {
//     title: string;
//     description?: string;
//     color?: "primary" | "success" | "error" | "warning" | "info" | "gray";
//     duration?: number;
//   }) => {
//     toast.add({
//       title: options.title,
//       description: options.description,
//       color: options.color || "primary",
//       timeout: options.duration ?? 3000,
//     });
//   };

//   const remove = (id: string) => {
//     toast.remove(id);
//   };

//   return {
//     add,
//     remove,
//   };
// };
