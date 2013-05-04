
app:
	coffee --output js --compile src

watch:
	coffee --output js --watch src

.PHONY: app watch
