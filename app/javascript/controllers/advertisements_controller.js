import { Controller } from "@hotwired/stimulus"

export default class extends Controller{
    static targets = ["categorySelect", "form", "dynamicFields"]

    connect() {
        this.showDynamicFields();
        this.categorySelectTarget.addEventListener('change', () => {
            this.showDynamicFields();
        });
    }

    showDynamicFields(){
        const categoryID = this.categorySelectTarget.value
        const dynamicFields = this.dynamicFieldsTarget

        // Тут мы очищаем предыдущие поля
        dynamicFields.innerHTML = ""

        switch (categoryID){
            case '1': this.addTransportFields(); break;
            case '2': this.addRealEstateFields(); break;
            case '3': this.addServiceFields(); break;
            case '4': this.addThingFields(); break;
            case '5': this.addJobFields(); break;
        }
    }

    addTransportFields(){
        const fields = [
            { name: 'brand', label: 'Марка', type: 'text', required: true },
            { name: 'model', label: 'Модель', type: 'text', required: true },
            { name: 'year', label: 'Год выпуска', type: 'text', required: true },
            { name: 'mileage', label: 'Пробег (км)', type: 'number', required: true },
            { name: 'fuel_type', label: 'Тип топлива', type: 'select',
                options: ['Бензин', 'Дизель', 'Электричество', 'Гибрид', 'ГБО'], required: true },
            { name: 'transmission', label: 'Коробка передач', type: 'select',
                options: ['Автомат' ,'Вариатор', 'Робот', 'Механическая'], required: true },
            { name: 'engine_capacity', label: 'Объем двигателя (см³)', type: 'number', required: true }
        ]
        this.createDynamicFields(fields);
    }

    addRealEstateFields(){
        const fields = [
            { name: 'property_type', label: 'Тип недвижимости', type: 'select',
                options: ['Квартира', 'Дом', 'Комната', 'Земельный участок'], required: true },
            { name: 'total_area', label: 'Общая площадь (м²)', type: 'number', step: '0.1', required: true },
            { name: 'living_area', label: 'Жилая площадь (м²)', type: 'number', step: '0.1', required: true },
            { name: 'floor', label: 'Этаж', type: 'number', required: true },
            { name: 'total_floors', label: 'Этажей в доме', type: 'number', required: true },
            { name: 'rooms_count', label: 'Количество комнат', type: 'number', required: true }
        ]
        this.createDynamicFields(fields);
    }

    addServiceFields(){
        const fields = [
            { name: 'name', label: 'Название услуги', type: 'text', required: true }
        ];

        this.createDynamicFields(fields);
    }

    addThingFields(){
        const fields = [
            { name: 'name', label: 'Название вещи', type: 'text', required: true },
            { name: 'item_type', label: 'Тип вещи', type: 'select', required: true,
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
                ]
            }
        ];

        this.createDynamicFields(fields);
    }

    addJobFields(){
        const fields = [
            { name: 'name', label: 'Название вакансии', type: 'text', required: true }
        ];

        this.createDynamicFields(fields);
    }

    createDynamicFields(fields){
        const container = this.dynamicFieldsTarget;

        fields.forEach(field =>
        {
            const div = document.createElement('div');
            div.className = 'field';
            const label = document.createElement('label');
            label.className = 'block text-sm font-medium text-gray-700';
            label.textContent = field.label;
            label.htmlFor = field.name;

            let input;

            if (field.type === 'select') {
                input = document.createElement('select');
                input.className = 'mt-1 block w-full pl-3 pr-10 py-2 text-base border border-gray-300 focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm rounded-md';
                input.name = `advertisement[${field.name}]`;
                input.id = field.name;
                input.required = field.required;

                const emptyOption = document.createElement('option');
                emptyOption.value = '';
                emptyOption.textContent = 'Выберите...';
                input.appendChild(emptyOption);

                field.options.forEach(option => {
                    const optionElement = document.createElement('option');
                    optionElement.value = option;
                    optionElement.textContent = option;
                    input.appendChild(optionElement);
                });
            } else {
                input = document.createElement('input');
                input.type = field.type;
                input.className = 'mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm';
                input.name = `advertisement[${field.name}]`;
                input.id = field.name;
                input.required = field.required;

                if (field.step) input.step = field.step;
                if (field.placeholder) input.placeholder = field.placeholder;
            }

            div.appendChild(label);
            div.appendChild(input);
            container.appendChild(div);
        });
    }
}