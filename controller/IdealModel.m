   function result = IdealModel(A,B,state,ref,F)
        % AT-MEC �⏞�Q�C���`���[�j���O��FRIT�A���S���Y���̗��z���f��M���܂ތv�Z
        % IdealModel(A,B,state,ref,F)
        % A,B : ���U��������ԋ�ԕ\���W��
        % state : �X�V�������o��
        % ref : �ڕW�l M*ref
        % F : �m�~�i���R���g���[��
        u = F * (ref - state);
        state = A * state + B * u;
        result = state;
    end