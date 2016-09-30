import click
import csv
import json


@click.command()
@click.argument("input_file", type=click.File("r"))
@click.argument("output_file", type=click.File("w"))
def main(input_file, output_file):
    writer = csv.writer(output_file)
    writer.writerow([
        "update_type",
        "text",
        "date",
        "from_name",
        "from_id"
    ])
    for line in input_file:
        json_object = json.loads(line)
        try:
            if "action" in json_object:
                update_type = json_object["action"]["type"]
                if update_type is "chat_rename":
                    text = json_object["action"]["title"]
                elif update_type in ["chat_add_user", "chat_del_user"]:
                    text = json_object["action"]["user"]["print_name"]
                else:  # skip change photo or other action
                    continue
            elif "media" in json_object:
                update_type = json_object["media"]["type"]
                text = ""
            else:
                update_type = "message"
                text = json_object["text"]
            date = json_object["date"]
            from_name = json_object["from"]["print_name"]
            from_id = json_object["from"]["peer_id"]
            writer.writerow([
                update_type,
                text,
                date,
                from_name,
                from_id
            ])
        except KeyError:
            print(json_object)
            break


if __name__ == "__main__":
    main()
