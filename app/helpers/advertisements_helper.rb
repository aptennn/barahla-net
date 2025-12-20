module AdvertisementsHelper
  def render_category_fields(advertisement)
    return '' unless advertisement.category_detail

    case advertisement.category_id
    when 1
      render_transport_fields(advertisement.transport)
    when 2
      render_real_estate_fields(advertisement.real_estate)
    when 3
      render_service_fields(advertisement.service)
    when 4
      render_thing_fields(advertisement.thing)
    when 5
      render_job_fields(advertisement.job)
    else
      ''
    end
  end

  def render_category_fields_display(advertisement)
    return '' unless advertisement.category_detail

    case advertisement.category_id
    when 1
      render_transport_display(advertisement.transport)
    when 2
      render_real_estate_display(advertisement.real_estate)
    when 3
      render_service_display(advertisement.service)
    when 4
      render_thing_display(advertisement.thing)
    when 5
      render_job_display(advertisement.job)
    else
      ''
    end
  end

  private
  def render_transport_fields(transport)
    return '' unless transport

    fields = [
      { name: 'brand', label: 'Марка', type: 'text', value: transport.brand },
      { name: 'model', label: 'Модель', type: 'text', value: transport.model },
      { name: 'year', label: 'Год выпуска', type: 'text', value: transport.year },
      { name: 'mileage', label: 'Пробег (км)', type: 'number', value: transport.mileage },
      { name: 'fuel_type', label: 'Тип топлива', type: 'select', value: transport.fuel_type,
        options: ['Бензин', 'Дизель', 'Электричество', 'Гибрид', 'ГБО'] },
      { name: 'transmission', label: 'Коробка передач', type: 'select', value: transport.transmission,
        options: ['Автомат', 'Вариатор', 'Робот', 'Механическая'] },
      { name: 'engine_capacity', label: 'Объем двигателя (см³)', type: 'number', value: transport.engine_capacity }
    ]

    render_dynamic_fields(fields)
  end

  def render_real_estate_fields(real_estate)
    return '' unless real_estate

    fields = [
      { name: 'property_type', label: 'Тип недвижимости', type: 'select', value: real_estate.property_type,
        options: ['Квартира', 'Дом', 'Комната', 'Земельный участок'] },
      { name: 'total_area', label: 'Общая площадь (м²)', type: 'number', step: '0.1', value: real_estate.total_area },
      { name: 'living_area', label: 'Жилая площадь (м²)', type: 'number', step: '0.1', value: real_estate.living_area },
      { name: 'floor', label: 'Этаж', type: 'number', value: real_estate.floor },
      { name: 'total_floors', label: 'Этажей в доме', type: 'number', value: real_estate.total_floors },
      { name: 'rooms_count', label: 'Количество комнат', type: 'number', value: real_estate.rooms_count }
    ]

    render_dynamic_fields(fields)
  end

  def render_service_fields(service)
    return '' unless service

    fields = [
      { name: 'name', label: 'Название услуги', type: 'text', value: service.name }
    ]

    render_dynamic_fields(fields)
  end

  def render_thing_fields(thing)
    return '' unless thing

    fields = [
      { name: 'name', label: 'Название вещи', type: 'text', value: thing.name },
      { name: 'item_type', label: 'Тип вещи', type: 'select', value: thing.item_type,
        options: [
          'Электроника',
          'Одежда и обувь',
          'Мебель',
          'Бытовая техника',
          'Книги',
          'Спортивный инвентарь',
          'Детские товары',
          'Косметика',
          'Инструменты',
          'Антиквариат',
          'Другое'
        ] }
    ]

    render_dynamic_fields(fields)
  end

  def render_job_fields(job)
    return '' unless job

    fields = [
      { name: 'name', label: 'Название вакансии', type: 'text', value: job.name }
    ]

    render_dynamic_fields(fields)
  end
  def filter_count
    count = 0
    count += 1 if params[:category_id].present?
    count += 1 if params[:city_id].present?
    count += 1 if params[:status].present?
    count += 1 if params[:min_price].present? || params[:max_price].present?
    count += params.keys.grep(/^brand|model|year_|fuel_|property_|rooms_|service_|item_|job_/).size
    count.positive? ? count : "0"
  end
  def advertisement_owner?(advertisement)
    current_user && advertisement.user_id == current_user.id
  end
  def render_category_filter_fields(category_id, params = {})
    return ''.html_safe unless category_id.in?([1, 2, 3, 4, 5])

    fields = case category_id
             when 1
               transport_filter_fields(params)
             when 2
               real_estate_filter_fields(params)
             when 3
               service_filter_fields(params)
             when 4
               thing_filter_fields(params)
             when 5
               job_filter_fields(params)
             end

    return ''.html_safe if fields.blank?

    content_tag :div, class: "space-y-3" do
      fields.map do |field|
        content_tag(:div) do
          label = content_tag(:label, field[:label],
                              class: "block text-sm text-gray-600 mb-1",
                              for: "filter_#{field[:name]}")

          input = if field[:type] == 'select'
                    options = [["Любой", ""]] + field[:options].map { |opt| [opt, opt] }
                    select_tag("filter_#{field[:name]}",
                               options_for_select(options, params[field[:name]]),
                               class: "w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-1 focus:ring-blue-500",
                               id: "filter_#{field[:name]}",
                               name: field[:name]
                    )
                  else
                    input_opts = {
                      class: "w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-1 focus:ring-blue-500",
                      type: field[:type],
                      id: "filter_#{field[:name]}",
                      name: field[:name],
                      value: params[field[:name]]
                    }
                    input_opts[:placeholder] = field[:placeholder] if field[:placeholder]
                    input_opts[:min] = field[:min] if field[:min]
                    input_opts[:step] = field[:step] if field[:step]
                    tag.input(input_opts)
                  end

          label + input
        end
      end.join.html_safe
    end
  end

  # Поля для фильтрации (аналогично редактированию, но с префиксом `filter_`)
  def transport_filter_fields(params)
    [
      { name: 'brand', label: 'Марка', type: 'text', placeholder: 'BMW, Lada' },
      { name: 'model', label: 'Модель', type: 'text', placeholder: 'X5, Granta' },
      { name: 'year_from', label: 'Год от', type: 'number', min: 1900, placeholder: Date.today.year - 20 },
      { name: 'year_to', label: 'до', type: 'number', min: 1900, placeholder: Date.today.year },
      { name: 'fuel_type', label: 'Топливо', type: 'select',
        options: ['Бензин', 'Дизель', 'Электричество', 'Гибрид', 'ГБО'] },
      { name: 'transmission', label: 'Коробка', type: 'select',
        options: ['Автомат', 'Вариатор', 'Робот', 'Механическая'] },
      { name: 'mileage_to', label: 'Пробег до (км)', type: 'number', placeholder: '100000' }
    ]
  end

  def real_estate_filter_fields(params)
    [
      { name: 'property_type', label: 'Тип', type: 'select',
        options: ['Квартира', 'Дом', 'Комната', 'Земельный участок'] },
      { name: 'rooms_count', label: 'Комнат', type: 'number', min: 0, placeholder: '1' },
      { name: 'total_area_from', label: 'Площадь от (м²)', type: 'number', step: '0.1', placeholder: '30' },
      { name: 'total_area_to', label: 'до', type: 'number', step: '0.1', placeholder: '100' },
      { name: 'floor_from', label: 'Этаж от', type: 'number', min: 0, placeholder: '1' },
      { name: 'total_floors_from', label: 'Этажность от', type: 'number', min: 1, placeholder: '5' }
    ]
  end
  def category_filter_title(category_id)
    case category_id
    when "1" then "Транспорт"
    when "2" then "Недвижимость"
    when "3" then "Услуги"
    when "4" then "Вещи"
    when "5" then "Работа"
    else "Дополнительно"
    end
  end

  def filter_template_name(category_id)
    case category_id
    when "1" then "transport_filters"
    when "2" then "real_estate_filters"
    when "3" then "service_filters"
    when "4" then "thing_filters"
    when "5" then "job_filters"
    else "empty"
    end
  end
  def service_filter_fields(params)
    [
      { name: 'service_name', label: 'Название услуги', type: 'text', placeholder: 'Ремонт, репетитор' }
    ]
  end

  def thing_filter_fields(params)
    [
      { name: 'thing_name', label: 'Название вещи', type: 'text', placeholder: 'iPhone, куртка' },
      { name: 'item_type', label: 'Тип вещи', type: 'select',
        options: [
          'Электроника', 'Одежда и обувь', 'Мебель', 'Бытовая техника',
          'Книги', 'Спортивный инвентарь', 'Детские товары',
          'Косметика', 'Инструменты', 'Антиквариат', 'Другое'
        ] }
    ]
  end

  def job_filter_fields(params)
    [
      { name: 'job_name', label: 'Название вакансии', type: 'text', placeholder: 'Программист, курьер' }
    ]
  end
  def render_dynamic_fields(fields)
    fields.map do |field|
      content_tag(:div, class: 'field') do
        label = content_tag(:label, field[:label], class: 'block text-sm font-medium text-gray-700', for: field[:name])

        input = if field[:type] == 'select'
                  select_tag("advertisement[#{field[:name]}]",
                             options_for_select(field[:options], field[:value]),
                             class: 'mt-1 block w-full pl-3 pr-10 py-2 text-base border border-gray-300 focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm rounded-md',
                             id: field[:name],
                             name: "advertisement[#{field[:name]}]")
                else
                  input_options = {
                    class: 'mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm',
                    type: field[:type],
                    id: field[:name],
                    name: "advertisement[#{field[:name]}]"
                  }
                  input_options[:step] = field[:step] if field[:step]
                  text_field_tag("advertisement[#{field[:name]}]", field[:value], input_options)
                end

        label + input
      end
    end.join.html_safe
  end

  def render_transport_display(transport)
    return '' unless transport

    fields = [
      { label: 'Марка', value: transport.brand },
      { label: 'Модель', value: transport.model },
      { label: 'Год выпуска', value: transport.year },
      { label: 'Пробег (км)', value: number_with_delimiter(transport.mileage) },
      { label: 'Тип топлива', value: transport.fuel_type },
      { label: 'Коробка передач', value: transport.transmission },
      { label: 'Объем двигателя (см³)', value: number_with_delimiter(transport.engine_capacity) }
    ].reject { |f| f[:value].blank? }

    render_display_grid(fields)
  end

  def render_real_estate_display(real_estate)
    return '' unless real_estate

    fields = [
      { label: 'Тип недвижимости', value: real_estate.property_type },
      { label: 'Общая площадь (м²)', value: number_with_precision(real_estate.total_area, precision: 1) },
      { label: 'Жилая площадь (м²)', value: number_with_precision(real_estate.living_area, precision: 1) },
      { label: 'Этаж', value: real_estate.floor },
      { label: 'Этажей в доме', value: real_estate.total_floors },
      { label: 'Количество комнат', value: real_estate.rooms_count }
    ].reject { |f| f[:value].blank? }

    render_display_grid(fields)
  end

  def render_service_display(service)
    return '' unless service

    fields = [
      { label: 'Название услуги', value: service.name, full_width: true }
    ].reject { |f| f[:value].blank? }

    render_display_grid(fields)
  end

  def render_thing_display(thing)
    return '' unless thing

    fields = [
      { label: 'Название вещи', value: thing.name, full_width: true },
      { label: 'Тип вещи', value: thing.item_type }
    ].reject { |f| f[:value].blank? }

    render_display_grid(fields)
  end

  def render_job_display(job)
    return '' unless job

    fields = [
      { label: 'Название вакансии', value: job.name, full_width: true }
    ].reject { |f| f[:value].blank? }

    render_display_grid(fields)
  end

  def render_display_grid(fields)
    return '' if fields.empty?

    # Если есть full_width поле, показываем его отдельно
    full_width_fields = fields.select { |f| f[:full_width] }
    regular_fields = fields.reject { |f| f[:full_width] }

    content_tag(:div, class: 'space-y-4') do
      # Полноразмерные поля
      if full_width_fields.any?
        concat(
          content_tag(:div, class: 'space-y-3') do
            full_width_fields.map do |field|
              concat(
                content_tag(:div, class: 'field-display') do
                  content_tag(:div, class: 'grid grid-cols-1 gap-1') do
                    label = content_tag(:dt, field[:label], class: 'text-sm font-medium text-gray-500')
                    value = content_tag(:dd, field[:value], class: 'text-lg font-semibold text-gray-900')
                    label + value
                  end
                end
              )
            end.join.html_safe
          end
        )
      end

      # Регулярные поля в 2 колонки
      if regular_fields.any?
        concat(
          content_tag(:dl, class: 'grid grid-cols-1 md:grid-cols-2 gap-4') do
            regular_fields.map do |field|
              concat(
                content_tag(:div, class: 'bg-gray-50 rounded-lg p-4') do
                  label = content_tag(:dt, field[:label], class: 'text-sm font-medium text-gray-500 truncate')
                  value = content_tag(:dd, field[:value], class: 'mt-1 text-lg font-semibold text-gray-900')
                  label + value
                end
              )
            end.join.html_safe
          end
        )
      end
    end
  end
end

