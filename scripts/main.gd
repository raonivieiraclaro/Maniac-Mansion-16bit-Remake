extends Control

var language := "pt"
var hero := Vector2(180, 370)
var target := hero
var carrying := false
var state := "intro"
var messages := {
 "pt": ["Uma noite estranha. Uma mansão cheia de segredos.", "Raoni veio investigar o desaparecimento de uma amiga.", "Toque na tela para caminhar. Toque na caixa para movê-la.", "Raoni moveu a caixa pesada!", "O caminho está livre. Fim do protótipo."],
 "en": ["A strange night. A mansion full of secrets.", "Raoni came to investigate a friend's disappearance.", "Tap to walk. Tap the crate to move it.", "Raoni moved the heavy crate!", "The path is clear. Prototype complete."],
 "es": ["Una noche extraña. Una mansión llena de secretos.", "Raoni vino a investigar la desaparición de una amiga.", "Toca para caminar. Toca la caja para moverla.", "¡Raoni movió la caja pesada!", "El camino está libre. Fin del prototipo."],
 "de": ["Eine seltsame Nacht. Ein Haus voller Geheimnisse.", "Raoni untersucht das Verschwinden einer Freundin.", "Tippe zum Gehen. Tippe auf die Kiste.", "Raoni hat die schwere Kiste bewegt!", "Der Weg ist frei. Ende des Prototyps."],
 "fr": ["Une nuit étrange. Un manoir plein de secrets.", "Raoni enquête sur la disparition d'une amie.", "Touchez pour marcher. Touchez la caisse.", "Raoni a déplacé la caisse lourde !", "Le passage est libre. Fin du prototype."],
 "ja": ["奇妙な夜。秘密に満ちた屋敷。", "ラオニは友人の失踪を調べに来た。", "画面をタップして移動。箱をタップして動かそう。", "ラオニは重い箱を動かした！", "道が開いた。試作版終了。"],
 "zh": ["奇怪的夜晚，充满秘密的宅邸。", "拉奥尼来调查朋友的失踪。", "点击屏幕移动，点击箱子推动它。", "拉奥尼搬动了沉重的箱子！", "道路畅通。试玩结束。"]
}
var intro_index := 0

func _ready() -> void:
 queue_redraw()

func _process(delta: float) -> void:
 if state == "play":
  hero = hero.move_toward(target, delta * 190.0)
  queue_redraw()

func _gui_input(event: InputEvent) -> void:
 if event is InputEventScreenTouch and event.pressed:
  handle_touch(event.position)
 elif event is InputEventMouseButton and event.pressed:
  handle_touch(event.position)

func handle_touch(p: Vector2) -> void:
 if state == "intro":
  if p.y < 90:
   var codes := ["pt", "en", "es", "ja", "de", "zh", "fr"]
   language = codes[int(p.x / max(size.x / 7.0, 1.0)) % 7]
  else:
   intro_index += 1
   if intro_index >= 2:
    state = "play"
 elif state == "play":
  if not carrying and Rect2(610, 310, 115, 115).has_point(p):
   carrying = true
   target = Vector2(580, 370)
  else:
   target = Vector2(clampf(p.x, 35, size.x - 35), clampf(p.y, 280, size.y - 80))
 elif state == "end":
  state = "intro"
  intro_index = 0
 queue_redraw()

func _draw() -> void:
 var font := ThemeDB.fallback_font
 draw_rect(Rect2(Vector2.ZERO, size), Color("#15152b"))
 draw_rect(Rect2(0, 265, size.x, size.y - 265), Color("#353443"))
 draw_rect(Rect2(90, 95, 770, 230), Color("#38304d"))
 for i in range(5):
  draw_rect(Rect2(140 + i * 135, 145, 66, 96), Color("#11162b"))
 draw_rect(Rect2(470, 215, 110, 110), Color("#19111f"))
 if state == "intro":
  draw_string(font, Vector2(65, 65), "PT     EN     ES     JA     DE     ZH     FR", HORIZONTAL_ALIGNMENT_LEFT, -1, 23, Color.WHITE)
  draw_string(font, Vector2(100, 385), messages[language][intro_index], HORIZONTAL_ALIGNMENT_LEFT, -1, 23, Color.WHITE)
  draw_string(font, Vector2(270, 450), "REMAKE BY RAONI CLARO", HORIZONTAL_ALIGNMENT_LEFT, -1, 28, Color("#f2d37b"))
  draw_string(font, Vector2(260, 505), "TOQUE PARA CONTINUAR / TAP TO CONTINUE", HORIZONTAL_ALIGNMENT_LEFT, -1, 19, Color.WHITE)
 else:
  draw_rect(Rect2(hero.x - 15, hero.y - 58, 30, 40), Color("#3dbf61"))
  draw_rect(Rect2(hero.x - 17, hero.y - 68, 34, 12), Color.BLACK)
  draw_rect(Rect2(hero.x - 14, hero.y - 22, 28, 23), Color("#15151b"))
  if not carrying:
   draw_rect(Rect2(610, 310, 115, 115), Color("#876341"))
   draw_rect(Rect2(624, 325, 86, 86), Color("#a78153"), false, 5.0)
  var msg: String = str(messages[language][3] if carrying else messages[language][2])
  draw_string(font, Vector2(60, 495), msg, HORIZONTAL_ALIGNMENT_LEFT, -1, 23, Color.WHITE)
  if carrying and hero.distance_to(target) < 3:
   draw_string(font, Vector2(60, 530), messages[language][4], HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color("#f2d37b"))
