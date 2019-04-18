extends AudioStreamPlayer

func fade_out():
    $Tween.interpolate_property(self, "volume_db", 0, -80, 1, Tween.TRANS_EXPO, Tween.EASE_IN, 0)
    $Tween.start()