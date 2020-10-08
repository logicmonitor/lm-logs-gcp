build:
	go build && go test
	mkdir -p build
	zip -r function-source.zip .
	mv function-source.zip ./build
clean:
	rm -rf build
test:
	go test
