// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

import "controllers"
import { Turbo } from "@hotwired/turbo-rails";
import * as ActionCable from "@rails/actioncable";
import "channels"
window.Turbo = Turbo;
window.cable = ActionCable.createConsumer();
window.App ||= {};
window.App.cable = createConsumer();