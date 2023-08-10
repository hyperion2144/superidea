default: gen lint

gen:
    flutter pub get
    flutter_rust_bridge_codegen

lint:
    cargo fmt
    dart format .

clean:
    flutter clean
    cargo clean
    
serve *args='':
    flutter pub run flutter_rust_bridge:serve {{args}}

# vim:expandtab:sw=4:ts=4
