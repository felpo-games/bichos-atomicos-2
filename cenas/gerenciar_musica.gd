extends Node

func tocar_menu():
	if $MusicaMenu.playing:
		return
	$MusicaMundo.stop()
	$MusicaMenu.play()

func tocar_mundo():
	if $MusicaMundo.playing:
		return
	$MusicaMenu.stop()
	$MusicaMundo.play()
