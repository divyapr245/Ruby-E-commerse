ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    div class: "px-4 py-16 md:py-32 text-center m-auto max-w-3xl" do
      h2 "Welcome to ActiveAdmin", class: "text-base font-semibold leading-7 text-indigo-600 dark:text-indigo-500"
      para "Live Login Count:", class: "mt-2 text-xl font-bold text-gray-900 dark:text-gray-200"
      
      # div do
      #   turbo_stream_from "login_count_channel"
      #   div id: "live_login_count" do
      #     render "admin/dashboard/live_login_count", login_count: 0
      #   end
      # end

      
     
    end
  end
end