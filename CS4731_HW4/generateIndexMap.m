function index_map = generateIndexMap(gray_stack, w_size)
% intensity is index of best focused layer for each point
index_map = zeros(size(gray_stack, 1), size(gray_stack,2));

% first compute focus measure for every pixel in every image in the stack
M = size(gray_stack,1);
N = size(gray_stack,2);
K = size(gray_stack,3);
focus_stack = zeros(M,N,K);

% go through each layer of stack
for i=1:K
    % laplacian at each point
    for r=1:M
        for c=1:N
            mult = 4;
            subval = 0;
            % edge cases
            if r==1
                mult = mult-1;
                subval = subval + gray_stack(r+1,c,i);
            elseif r==M
                mult = mult-1;
                subval = subval + gray_stack(r-1,c,i);
            else
                subval = subval + gray_stack(r-1,c,i) + gray_stack(r+1,c,i);
            end
            if c==1
                mult = mult-1;
                subval = subval + gray_stack(r,c+1,i);
            elseif c==N
                mult = mult-1;
                subval = subval + gray_stack(r,c-1,i);
            else
                subval = subval + gray_stack(r,c-1,i) + gray_stack(r,c+1,i);
            end
            % fill matrix here
            focus_stack(r,c,i) = abs(mult*gray_stack(r,c,i) - subval);
        end
    end
end
disp('Finished computing Laplacian at each point');
% second find the layer with maximal focus measure for each point

avg_stack = zeros(M,N,K);
% averaging
% go through each layer of stack
for i=1:K
    for r=1:M
        for c=1:N
            count = 0;
            % edge cases
            if r+w_size >= M
                count = count + sum(focus_stack(r:M,c,i));
            else
                count = count + sum(focus_stack(r:r+w_size,c,i));
            end
            if c+w_size >= N
                count = count + sum(focus_stack(r,c:N,i));
            else
                count = count + sum(focus_stack(r,c:c+w_size,i));
            end
            % fill matrix here
            avg_stack(r,c,i) = count/(w_size*w_size);
        end
    end
end
disp('Finished average filtering at each point');

% find maximal indices
[C,index_map] = max(avg_stack, [], 3);
disp('Completed generateIndexMap');