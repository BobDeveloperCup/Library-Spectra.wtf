import io, json, os, sys
import numpy as np
import cairosvg
from PIL import Image

atlas_path, lucide_icons_dir = sys.argv[1], sys.argv[2]
CELL, ICON = 25, 24

def render(path):
    svg = open(path).read().replace("currentColor", "white")
    png = cairosvg.svg2png(bytestring=svg.encode(), output_width=ICON, output_height=ICON)
    return np.array(Image.open(io.BytesIO(png)).convert("RGBA"))[:, :, 3].astype(np.float32) / 255

def normalize(a, size=26):
    ys, xs = np.where(a > 0.15)
    if len(ys) == 0:
        return None
    crop = a[ys.min():ys.max() + 1, xs.min():xs.max() + 1]
    if crop.shape[0] > size or crop.shape[1] > size:
        return None
    out = np.zeros((size, size), np.float32)
    out[:crop.shape[0], :crop.shape[1]] = crop
    return out.ravel() / (np.linalg.norm(out) + 1e-6)

atlas = np.array(Image.open(atlas_path).convert("RGBA"))[:, :, 3].astype(np.float32) / 255
names, vectors = [], []
for file in sorted(os.listdir(lucide_icons_dir)):
    if file.endswith(".svg"):
        vec = normalize(render(os.path.join(lucide_icons_dir, file)))
        if vec is not None:
            names.append(file[:-4])
            vectors.append(vec)
matrix = np.stack(vectors)

catalog = {}
for row in range(atlas.shape[0] // CELL):
    for col in range(atlas.shape[1] // CELL):
        if row < 2 and col < 2:
            continue
        vec = normalize(atlas[row * CELL:(row + 1) * CELL, col * CELL:(col + 1) * CELL])
        if vec is None:
            continue
        scores = matrix @ vec
        best = scores.max()
        if best >= 0.95:
            for index in np.where(scores >= best - 0.0006)[0]:
                catalog.setdefault(names[index], (col, row))

print(";".join(f"{n},{c},{r}" for n, (c, r) in sorted(catalog.items())))
