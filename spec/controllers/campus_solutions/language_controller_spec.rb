describe CampusSolutions::LanguageController do

  let(:user_id) { '12346' }

  context 'updating language' do
    it 'should not let an unauthenticated user post' do
      post :post, params: { format: 'json', uid: '100' }
      expect(response.status).to eq 401
    end

    context 'authenticated user' do
      before do
        session['user_id'] = user_id
        User::Auth.stub(:where).and_return([User::Auth.new(uid: user_id, is_superuser: false, active: true)])
      end
      it 'should let an authenticated user post' do
        post :post, params: {
          bogus_field: 'abc',
          languageCode: 'LEN',
          isNative: 'N',
          isTranslateToNative: 'N',
          isTeachLanguage: 'N',
          speakProf: '1',
          readProf: '2',
          teachLang: '3'
        }
        expect(response.status).to eq 200
        json = JSON.parse(response.body)
        expect(json['statusCode']).to eq 200
        expect(json['feed']).to be
        expect(json['feed']['status']).to be
      end
    end
  end

  context 'deleting language' do
    it 'should not let an unauthenticated user delete' do
      delete :delete, params: { format: 'json', languageCode: '100' }
      expect(response.status).to eq 401
    end

    context 'authenticated user' do
      before do
        session['user_id'] = user_id
        User::Auth.stub(:where).and_return([User::Auth.new(uid: user_id, is_superuser: false, active: true)])
      end
      it 'should let an authenticated user delete' do
        delete :delete, params: {
          bogus_field: 'abc',
          languageCode: 'LEN'
        }
        expect(response.status).to eq 200
        json = JSON.parse(response.body)
        expect(json['statusCode']).to eq 200
        expect(json['feed']).to be
        expect(json['feed']['status']).to be
      end
    end
  end

end
