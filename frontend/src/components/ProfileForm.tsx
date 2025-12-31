import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import {
  profileFormSchema,
  type ProfileFormData,
} from "@/types/resume";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { cn } from "@/lib/utils";

export function ProfileForm() {
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
  } = useForm<ProfileFormData>({
    // @ts-expect-error - zodResolver type compatibility issue with complex zod schemas
    resolver: zodResolver(profileFormSchema),
    defaultValues: {
      document_date: new Date().toISOString().split("T")[0],
    },
  });

  const onSubmit = async (data: ProfileFormData) => {
    try {
      const response = await fetch("http://localhost:3000/profiles", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          profile: {
            name: data.name,
            birthday: data.birthday,
            gender: data.gender,
            career_profile: data.career_profile || null,
            job_summary: data.job_summary || null,
            document_date: data.document_date,
          },
        }),
      });

      if (!response.ok) {
        const errorData = await response.json();
        console.error("Error:", errorData);
        alert(`エラーが発生しました: ${JSON.stringify(errorData.errors || errorData)}`);
        return;
      }

      const profile = await response.json();
      console.log("Profile created:", profile);
      alert("プロフィールが正常に作成されました！");
    } catch (error) {
      console.error("Error submitting form:", error);
      alert("送信に失敗しました。サーバーが起動しているか確認してください。");
    }
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="flex flex-col" style={{ gap: '1.5rem' }}>
      <div className="flex flex-col" style={{ gap: '0.5rem' }}>
        <Label htmlFor="name">
          氏名 <span className="text-red-500">*</span>
        </Label>
        <Input
          id="name"
          type="text"
          {...register("name")}
          placeholder="山田 太郎"
          className={cn(errors.name && "border-red-500")}
        />
        {errors.name && (
          <p className="text-sm text-red-500">{errors.name.message}</p>
        )}
      </div>

      <div className="flex flex-col" style={{ gap: '0.5rem' }}>
        <Label htmlFor="birthday">
          生年月日 <span className="text-red-500">*</span>
        </Label>
        <Input
          id="birthday"
          type="date"
          {...register("birthday")}
          className={cn(errors.birthday && "border-red-500")}
        />
        {errors.birthday && (
          <p className="text-sm text-red-500">{errors.birthday.message}</p>
        )}
      </div>

      <div className="flex flex-col" style={{ gap: '0.5rem' }}>
        <Label htmlFor="gender">性別</Label>
        <select
          id="gender"
          {...register("gender", { valueAsNumber: true })}
          className="h-10 w-full rounded-md border border-gray-300 bg-white px-3 py-2 text-sm text-gray-900 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
        >
          <option value="">選択してください</option>
          <option value="0">男性</option>
          <option value="1">女性</option>
          <option value="2">その他</option>
          <option value="3">回答しない</option>
        </select>
        {errors.gender && (
          <p className="text-sm text-red-500">{errors.gender.message}</p>
        )}
      </div>

      <div className="flex flex-col" style={{ gap: '0.5rem' }}>
        <Label htmlFor="career_profile">キャリアプロフィール</Label>
        <Textarea
          id="career_profile"
          {...register("career_profile")}
          rows={4}
          placeholder="あなたのキャリアについて簡潔に記入してください"
        />
        {errors.career_profile && (
          <p className="text-sm text-red-500">{errors.career_profile.message}</p>
        )}
      </div>

      <div className="flex flex-col" style={{ gap: '0.5rem' }}>
        <Label htmlFor="job_summary">職務要約</Label>
        <Textarea
          id="job_summary"
          {...register("job_summary")}
          rows={4}
          placeholder="職務要約を記入してください"
        />
        {errors.job_summary && (
          <p className="text-sm text-red-500">{errors.job_summary.message}</p>
        )}
      </div>

      <div className="flex flex-col" style={{ gap: '0.5rem' }}>
        <Label htmlFor="document_date">
          記入日 <span className="text-red-500">*</span>
        </Label>
        <Input
          id="document_date"
          type="date"
          {...register("document_date")}
          className={cn(errors.document_date && "border-red-500")}
        />
        {errors.document_date && (
          <p className="text-sm text-red-500">{errors.document_date.message}</p>
        )}
      </div>

      <Button type="submit" disabled={isSubmitting} className="w-full">
        {isSubmitting ? "送信中..." : "送信"}
      </Button>
    </form>
  );
}
