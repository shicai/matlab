function sc_make_train_list(base_dir, list_file, cate_file, use_full_path)
% % % 
% (C) Shicai Yang, 2015. All rights reserved.

% base_dir = 'H:\Data\ImageNet\ILSVRC2012\train';
if ~exist('list_file', 'var') || isempty(list_file)
    list_file = 'list_train.txt';
end
if ~exist('cate_file', 'var') || isempty(cate_file)
    cate_file = 'cate_synsets.txt';
end
if ~exist('use_full_path', 'var') || isempty(use_full_path)
    use_full_path = 0;
end

fcate = fopen(cate_file, 'w');
flist = fopen(list_file, 'w');

cate_list = dir(base_dir);
num_cate = length(cate_list) - 2;
cate_distrib = zeros(num_cate, 1);

fprintf(fcate, 'cate_id\tnum_images\tcate_name\n');
for i=3:length(cate_list)
    cate_name = cate_list(i).name;
    cate_id = i - 3;    
    cate_path = fullfile(base_dir, cate_name);
    img_list = dir(fullfile(cate_path, '*.*g'));
    num_images = length(img_list);
    cate_distrib(i-2) = num_images;
    fprintf(fcate, '%04d\t%04d\t%s\n', cate_id, num_images, cate_name);
    for j=1:num_images
        if (use_full_path == 1)
            file_name = fullfile(cate_path, img_list(j).name);
            file_name(strfind(file_name, '\')) = '/';
            fprintf(flist, '%s %d\n', file_name, cate_id);
        else
            fprintf(flist, '%s/%s %d\n', cate_name, img_list(j).name, cate_id);
        end
    end
end
fclose(fcate);
fclose(flist);
