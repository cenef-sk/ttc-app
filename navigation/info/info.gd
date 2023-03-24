extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	match Config.lng:
		"sk":
			$TextureRect/RichTextLabel.text = "Mobilná vzdelávacia aplikácia s hernými prvkami vznikla v rámci projektu Dotknite sa kultúry. Tento projekt je spolufinancovaný z programu Európskej únie Erasmus+.\n\n" \
				+ "Pomocou tejto aplikácie sa pokúšame o motiváciu a vzdelávanie širokej verejnosti ale hlavne mladých ľudí pomocou metód neformálneho vzdelávania a vzbudiť v nich záujem o kultúru.\n\n" \
				+ "Viac informácii nájdete na:"
		"en":
			$TextureRect/RichTextLabel.text = "The mobile educational application with game elements was created as part of the Touch the Culture project. This project is co-financed by the Erasmus+ program of the European Union.\n\n" \
				+ "With the help of this application, we are trying to motivate and educate the general public, but especially young people, using non-formal education methods and to arouse in them an interest in culture.\n\n" \
				+ "You can find more information at:"
		"cs":
			$TextureRect/RichTextLabel.text = "Mobilní vzdělávací aplikace s herními prvky vznikla v rámci projektu Dotkněte se kultury. Tento projekt je spolufinancován z programu Evropské unie Erasmus+.\n\n" \
				+ "Pomocí této aplikace se pokoušíme o motivaci a vzdělávání široké veřejnosti ale hlavně mladých lidí pomocí metod neformálního vzdělávání a vzbudit v nich zájem o kulturu.\n\n" \
				+ "Více informací naleznete na:"
		"pl":
			$TextureRect/RichTextLabel.text = "Mobilna aplikacja edukacyjna z elementami gry powstała w ramach projektu Touch the Culture. Projekt ten jest współfinansowany przez program Unii Europejskiej Erasmus+.\n\n" \
				+ "Za pomocą tej aplikacji staramy się motywować i edukować społeczeństwo, a zwłaszcza młodzież, metodami edukacji pozaformalnej i rozbudzać w nich zainteresowanie kulturą.\n\n" \
				+ "Więcej informacji można znaleźć pod adresem:"

func _on_TextureRect_gui_input(event):
	if (event is InputEventMouseButton && event.pressed):
		SceneTransition.change_scene("res://navigation/games/games2.tscn")


func _on_LinkRichText_gui_input(event):
	if (event is InputEventMouseButton && event.pressed):
		OS.shell_open("https://www.touchtheculture.eu")
