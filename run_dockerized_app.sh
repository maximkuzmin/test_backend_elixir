mix deps.get

case "$1" in
    prepare)
        mix ecto.create
        mix ecto.migrate
        mix import_professions_and_job_offers
        exit 0
        ;;
    *)

iex -S mix phx.server
exit 0
;;
esac
