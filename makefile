all:
	git checkout master README.md
	git checkout master chrome/data/example.tsv
	pandoc -s -c markdown7.css gif_header.md README.md -o index.html

quick:
	pandoc -s -c markdown7.css gif_header.md README.md -o index.html

