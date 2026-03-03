import { redirect } from "next/navigation";
import { getSupabaseServer } from "@/lib/supabase";

export default async function SpecDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;

  const supabase = getSupabaseServer();
  const { data } = await supabase
    .from("sources")
    .select("id")
    .eq("tier", "2a")
    .eq("status", "active")
    .or(`metadata->>json_id.eq.${id},title.ilike.%${id.replace(/-/g, " ")}%`)
    .limit(1);

  if (data && data.length > 0) {
    redirect(`/sources/${data[0].id}`);
  }

  redirect("/specs");
}
