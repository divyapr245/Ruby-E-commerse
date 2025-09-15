import { createConsumer } from "@rails/actioncable";

const consumer = createConsumer();

export default consumer;
import "./chats_channel"
import "./message_notification_channel"
import "./presence_channel"
import "./user_channel"
