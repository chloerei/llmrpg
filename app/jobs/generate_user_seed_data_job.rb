class GenerateUserSeedDataJob < ApplicationJob
  queue_as :default

  def perform(user)
    character = user.characters.create(
      name: I18n.t("seeds.character.name"),
      prompt: I18n.t("seeds.character.prompt")
    )

    room = user.rooms.create(
      name: I18n.t("seeds.room.name"),
      prompt: I18n.t("seeds.room.prompt")
    )

    room.members.create(character: character)

    conversation = room.conversations.create(
      user: user,
      title: I18n.t("seeds.conversation.title"),
    )

    conversation.messages.create(
      content: I18n.t("seeds.message.content"),
      character: character,
      role: "assistant"
    )
  end
end
