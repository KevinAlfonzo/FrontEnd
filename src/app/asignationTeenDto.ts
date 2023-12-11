export class TeenDto {
    id_adolescent: number = 0;
}

export class asignationTeenDto{
    teens: TeenDto[] | undefined;
    id_program: number = 0;
    assignment_date: string = ''
}