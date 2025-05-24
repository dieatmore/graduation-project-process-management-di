create table if not exists `department`
(
    id          char(19)       not null primary key,
    name        varchar(20)    not null,
    insert_time datetime       not null default current_timestamp,
    update_time datetime       not null default current_timestamp on update current_timestamp
);

create table if not exists `user`
(
    id            char(19)         not null primary key,
    number        varchar(20)      unique not null,
    password      varchar(65)      not null,
    name          varchar(20)      not null,
    department_id char(19)         not null,
    role          varchar(20)      not null,
    student       json             comment '{"year", "teacherId", "projectTitle"}',
    teacher       json             comment '{"teachNumber"}',
    score         tinyint unsigned null,
    insert_time   datetime         not null default current_timestamp,
    update_time   datetime         not null default current_timestamp on update current_timestamp,

    index((cast( student ->> '$.teacherId' as char(19)) collate utf8mb4_bin))
);

create table if not exists `process`
(
    id              char(19)           not null primary key,
    name            varchar(20)        not null,
    items           json               comment '[{"number", "name", "point", "description"}]',
    proportion      varchar(20)        not null,
    department_id   char(19)           not null,
    year            year               not null,
    file_path       varchar(20),
    insert_time     datetime           not null default current_timestamp,
    update_time     datetime           not null default current_timestamp on update current_timestamp,

    unique(department_id, year)
);

create table if not exists 'process_group'
(
    id               char(19)       not null primary key,
    process_id       char(19)       not null,
    teacher_id       char(19)       not null,
    student_id       char(19)       not null,
    order            varchar(20)    not null,
    insert_time      datetime       not null default current_timestamp,
    update_time      datetime       not null default current_timestamp on update current_timestamp,

    index(teacher_id),
    index(student_id)
);

create table if not exists `process_score`
(
    id            char(19)    not null primary key,
    student_id    char(19)    not null,
    process_id    char(19)    not null,
    teacher_id    char(19)    not null,
    detail        json        not null comment '{"score", item: [{"number", "name", "score"}]}',
    insert_time   datetime    not null default current_timestamp,
    update_time   datetime    not null default current_timestamp on update current_timestamp,

    unique(student_id, process_id, teacher_id)
);