parts = ~w(head_neck hand_l hand_r pelvis lumbar5 thoracic12 thoracic1 clavicle_l humerus_l radius_l
           clavicle_r humerus_r radius_r femur_l tibia_l calcn_l toes_l femur_r tibia_r calcn_r toes_r)

[src, dst] = System.argv()

rows =
  src
  |> File.read!()
  |> String.split("\n")
  |> Enum.drop_while(&(not String.starts_with?(&1, "# anny_bone")))
  |> Enum.drop(1)
  |> Enum.reject(&(&1 == ""))
  |> Enum.map(fn line ->
    [bone, body, pair] = String.split(line, "\t")

    names =
      case pair do
        "None" -> ["", "", "", ""]
        _ -> Regex.scan(~r/'([^']+)'/, pair, capture: :all_but_first) |> List.flatten()
      end

    4 = length(names)
    [bone, body | names]
  end)

bodies = rows |> Enum.map(&Enum.at(&1, 1)) |> Enum.uniq()
[] = bodies -- parts
[] = parts -- bodies

sorted = Enum.flat_map(parts, fn p -> Enum.filter(rows, &(Enum.at(&1, 1) == p)) end)
true = length(sorted) == length(rows)
keys = ~w(anny_bone mujoco_body anny_from anny_to mujoco_from mujoco_to)
vsekai = "https://v-sekai.org/"
context = Map.new(keys, &{&1, "VSEKAI:drive/" <> &1}) |> Map.merge(%{"VSEKAI" => vsekai, "rows" => %{"@container" => "@list", "@id" => "VSEKAI:drive/rows"}})
table = %{"@context" => context, "@type" => "VSEKAI:drive/Table", "rows" => Enum.map(sorted, &Map.new(Enum.zip(keys, &1)))}

defmodule Canonical do
  def encode(m) when is_map(m), do: "{" <> (m |> Enum.sort() |> Enum.map_join(",", fn {k, v} -> encode(k) <> ":" <> encode(v) end)) <> "}"
  def encode(l) when is_list(l), do: "[" <> Enum.map_join(l, ",", &encode/1) <> "]"
  def encode(s) when is_binary(s), do: s |> :json.encode() |> IO.iodata_to_binary()
  def encode(n) when is_integer(n), do: Integer.to_string(n)
end

File.write!(dst, Canonical.encode(table) <> "\n")
IO.puts("#{length(sorted)} rows, #{length(bodies)} driving bodies -> #{dst}")
