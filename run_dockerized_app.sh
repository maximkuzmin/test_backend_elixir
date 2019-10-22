mix deps.get

case "$1" in
    prepare)
        mix ecto.create
        mix ecto.migrate
        exit 0
        ;;
    import)
        echo 1
        exit 0
        ;;
    *)

iex -S mix phx.server
exit 0
;;
esac
